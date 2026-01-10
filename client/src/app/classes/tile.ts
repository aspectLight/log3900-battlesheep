import { ErrorMessages } from '@app/constants/error-messages.constants';
import { TILE_TYPES } from '@app/constants/tile.constants';

export class Tile {
    type: string;
    state: string;
    orientation: string;
    moveModifier: number;
    imagePath: string;
    description: string;

    constructor(type: string, orientation?: string, state?: string) {
        const tileData = TILE_TYPES[type];
        if (!tileData) {
            throw new Error(`${ErrorMessages.InvalidTile} ${type}`);
        }

        this.type = type;
        this.state = state || tileData.defaultState;
        this.orientation = orientation || tileData.defaultOrientation;
        this.description = tileData.description;

        this.updateProperties();
    }

    clone(): Tile {
        return new Tile(this.type, this.orientation, this.state);
    }

    toggleState(): void {
        const tileData = TILE_TYPES[this.type];

        if (tileData.states && tileData.states.length > 0) {
            const currentIndex = tileData.states.indexOf(this.state);
            const nextIndex = (currentIndex + 1) % tileData.states.length;
            this.state = tileData.states[nextIndex];
            this.updateProperties();
        }
    }

    toggleRotation(): void {
        const tileData = TILE_TYPES[this.type];

        if (tileData.rotations && tileData.rotations.length > 0) {
            const currentIndex = tileData.rotations.indexOf(this.orientation);
            const nextIndex = (currentIndex + 1) % tileData.rotations.length;
            this.orientation = tileData.rotations[nextIndex];
            this.updateProperties();
        }
    }

    private updateProperties(): void {
        const tileData = TILE_TYPES[this.type];
        const key = `${this.state}${this.orientation}`;

        let imagePathCandidate = tileData.images[key];

        if (!imagePathCandidate && this.orientation.includes('_')) {
            const baseOrientation = this.orientation.split('_')[0];
            const fallbackKey = `${this.state}${baseOrientation}`;
            imagePathCandidate = tileData.images[fallbackKey];
        }

        if (!imagePathCandidate) {
            imagePathCandidate = tileData.images.default;
        }

        const willGenerateVariant = Math.random() < (tileData.variantProbability || 0);
        if (tileData.variants && willGenerateVariant) {
            const randomIndex = Math.floor(Math.random() * tileData.variants.length);
            this.imagePath = tileData.variants[randomIndex];
        } else {
            this.imagePath = imagePathCandidate;
        }
        this.moveModifier = tileData.baseMoveModifier;
    }
}
