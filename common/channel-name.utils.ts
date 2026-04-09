const RESERVED_GENERAL_CHANNEL_NAMES = new Set(['general', 'generale', 'général', 'générale']);

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
