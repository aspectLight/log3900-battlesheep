import { AbstractControl, ValidationErrors, ValidatorFn } from '@angular/forms';

const BANNED_USERNAMES = ['supprime', 'deleted'];

export const bannedUsernameValidator: ValidatorFn = (control: AbstractControl): ValidationErrors | null => {
    const value: string = (control.value ?? '').toLowerCase().trim();
    return BANNED_USERNAMES.includes(value) ? { bannedUsername: true } : null;
};
