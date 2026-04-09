const RESERVED_GENERAL_CHANNEL_NAMES = new Set(['general', 'generale']);

const GAME_CHANNEL_NAME_PATTERNS = [
    /^partie(?: [a-z0-9]+)?$/,
    /^canal de partie(?: [a-z0-9]+)?$/,
    /^channel for partie(?: [a-z0-9]+)?$/,
    /^game channel(?: [a-z0-9]+)?$/,
    /^games channel(?: [a-z0-9]+)?$/,
];

/**
 * Normalise un nom de canal pour comparaison:
 * - trim + lowercase
 * - suppression des accents
 * - suppression des caracteres non alphanumeriques
 */
export function normalizeChannelNameForComparison(name: string): string {
    return name
        .trim()
        .toLowerCase()
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '')
        .replace(/[^a-z0-9]/g, '');
}

/**
 * Blocage des variantes reservees du canal general.
 * Exemples bloques: "General", "general", "generale", "g e n e r a l".
 */
export function isReservedGeneralChannelName(name: string): boolean {
    const normalized = normalizeChannelNameForComparison(name);
    return RESERVED_GENERAL_CHANNEL_NAMES.has(normalized);
}

/**
 * Blocage des noms ressemblant aux canaux de partie auto-generes.
 * Exemples bloques: "Partie 1234", "Canal de partie", "Canal de partie 1234", "Game's channel".
 */
export function isReservedGameChannelName(name: string): boolean {
    const normalized = name
        .trim()
        .toLowerCase()
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '')
        .replace(/[\u2019']/g, '')
        .replace(/[^a-z0-9]+/g, ' ')
        .trim();

    return GAME_CHANNEL_NAME_PATTERNS.some((pattern) => pattern.test(normalized));
}