import { Component } from '@angular/core';
import { ReactiveFormsModule, Validators, FormBuilder } from '@angular/forms';

type AvatarOption = { id: string; label: string };

@Component({
    selector: 'app-signup-page',
    imports: [ReactiveFormsModule],
    templateUrl: './signup.component.html',
    styleUrl: './signup.component.scss',
})
export class SignUpPageComponent {
    avatars: AvatarOption[] = [
        { id: 'avatar_01', label: 'Avatar 1' },
        { id: 'avatar_02', label: 'Avatar 2' },
        { id: 'avatar_03', label: 'Avatar 3' },
        { id: 'avatar_04', label: 'Avatar 4' },
        { id: 'avatar_05', label: 'Avatar 5' },
    ];

    form = this.fb.group({
        firstName: ['', [Validators.required, Validators.minLength(2), Validators.pattern(/^[a-zA-Z]+$/)]],
        lastName: ['', [Validators.required, Validators.minLength(2), Validators.pattern(/^[a-zA-Z]+$/)]],
        email: ['', [Validators.required, Validators.email, Validators.pattern(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)]],
        password: ['', [Validators.required, Validators.minLength(8)]],
        avatarId: ['', [Validators.required]],
    });

    constructor(private fb: FormBuilder) {}

    get selectedAvatarId(): string {
        return this.form.controls.avatarId.value ?? '';
    }

    selectAvatar(id: string) {
        this.form.controls.avatarId.setValue(id);
        this.form.controls.avatarId.markAsTouched();
    }

    submitForm() {
        this.form.markAllAsTouched();

        if (this.form.invalid) return;

        const { firstName, lastName, email, password, avatarId } = this.form.getRawValue();

        // eslint-disable-next-line no-console
        console.log({ firstName, lastName, email, password, avatarId });
    }
}
