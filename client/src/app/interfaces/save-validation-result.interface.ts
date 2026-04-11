export interface SaveValidationResult {
    isValid: boolean;
    message?: string;
    messageParams?: Record<string, unknown>;
}
