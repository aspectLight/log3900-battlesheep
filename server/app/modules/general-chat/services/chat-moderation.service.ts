/* eslint-disable @typescript-eslint/naming-convention */
import { BannedWord, BannedWordDocument } from '@app/modules/general-chat/schemas/banned-words.schema';
import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

/**
 * Service de modération du chat qui censure les mots bannis.
 * Charge les mots activés au démarrage et les met en cache en mémoire.
 */
@Injectable()
export class ChatModerationService implements OnModuleInit {
    private readonly logger = new Logger(ChatModerationService.name);
    private bannedWordsSet: Set<string> = new Set<string>();

    constructor(
        @InjectModel(BannedWord.name)
        private readonly bannedWordModel: Model<BannedWordDocument>,
    ) {}

    /**
     * Charge tous les mots bannis activés au démarrage du module.
     */
    async onModuleInit(): Promise<void> {
        await this.refreshCache();
        this.logger.log(`Cache des mots bannis initialisé avec ${this.bannedWordsSet.size} mots.`);
    }

    /**
     * Recharge le cache des mots bannis depuis la base de données.
     * Utile si des mots sont ajoutés/supprimés pendant l'exécution.
     */
    async refreshCache(): Promise<void> {
        try {
            const bannedWords = await this.bannedWordModel.find({ enabled: true }).select('word').lean().exec();
            this.bannedWordsSet = new Set<string>(bannedWords.map((doc) => this.normalizeWord(doc.word)));
            this.logger.log(`Cache des mots bannis rafraîchi: ${this.bannedWordsSet.size} mots.`);
        } catch (error) {
            this.logger.error(`Erreur lors du chargement des mots bannis: ${error.message}`);
            // En cas d'erreur, on garde l'ancien cache ou on initialise un Set vide
            if (this.bannedWordsSet.size === 0) {
                this.bannedWordsSet = new Set<string>();
            }
        }
    }

    /**
     * Censure un message en remplaçant les mots bannis par des astérisques.
     *
     * Règles:
     * - Match EXACT uniquement (pas de substring)
     * - Tokenise par mots complets (lettres, chiffres, accents)
     * - Normalise chaque token (lowercase + NFKD + suppression diacritiques)
     *
     * @param message Le message à censurer
     * @returns Le message censuré
     */
    censor(message: string): string {
        if (!message || this.bannedWordsSet.size === 0) {
            return message;
        }

        // Regex pour tokeniser les mots complets (lettres, chiffres, accents FR)
        // Supporte: A-Z, a-z, À-Ö, Ø-ö, ø-ÿ (accents français), 0-9
        const wordRegex = /[A-Za-zÀ-ÖØ-öø-ÿ0-9@$]+/g;
        let wasCensored = false;

        const censoredMessage = message.replace(wordRegex, (token) => {
            const normalizedToken = this.normalizeWord(token);

            // Retire les chiffres ajoutés au début ou à la fin AVANT normalisation
            const tokenWithoutEdgeDigits = token.replace(/^\d+|\d+$/g, '');
            const normalizedTokenWithoutEdgeDigits = this.normalizeWord(tokenWithoutEdgeDigits);
            if (
                this.bannedWordsSet.has(normalizedToken) ||
                (tokenWithoutEdgeDigits.length > 0 && this.bannedWordsSet.has(normalizedTokenWithoutEdgeDigits))
            ) {
                wasCensored = true;
                return '*'.repeat(token.length);
            }
            return token;
        });

        if (wasCensored) {
            this.logger.debug(`Message censuré: ${message.substring(0, 50)}...`);
        }

        return censoredMessage;
    }

    private normalizeWord(word: string): string {
        if (!word) {
            return '';
        }

        const leetMap: Record<string, string> = {
            '@': 'a',
            '4': 'a',
            '3': 'e',
            '1': 'i',
            '0': 'o',
            '$': 's',
            '5': 's',
            '7': 't',
        };

        const leetNormalized = word
            .split('')
            .map((char) => leetMap[char] ?? char)
            .join('');

        return leetNormalized
            .toLowerCase()
            .normalize('NFKD')
            .replace(/[\u0300-\u036f]/g, '');
    }
}
