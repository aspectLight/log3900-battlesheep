import { Tile } from '@app/classes/board/tile';
import { TILE_TYPES } from '@app/constants/tile.constants';

describe('Tile', () => {
    it('should create an instance', () => {
        expect(new Tile('water')).toBeTruthy();
    });

    it('should create a tile with valid type', () => {
        const tile = new Tile('water');
        expect(tile).toBeInstanceOf(Tile);
        expect(tile.type).toBe('water');
        expect(tile.state).toBe(TILE_TYPES['water'].defaultState);
        expect(tile.orientation).toBe(TILE_TYPES['water'].defaultOrientation);
        expect(tile.description).toBe(TILE_TYPES['water'].description);
        expect(tile.imagePath).toBe(TILE_TYPES['water'].images.default);
    });

    it('should throw an error for an invalid tile type', () => {
        expect(() => new Tile('invalidType')).toThrowError('Invalid tile type: invalidType');
    });

    it('should clone a tile correctly', () => {
        const tile = new Tile('water');
        const clone = tile.clone();
        expect(clone).not.toBe(tile);
        expect(clone.type).toBe(tile.type);
        expect(clone.state).toBe(tile.state);
        expect(clone.orientation).toBe(tile.orientation);
    });

    it('should toggle state if states exist', () => {
        const tile = new Tile('door');
        expect(tile.state).toBe('closed');
        tile.toggleState();
        expect(tile.state).toBe('opened');
        tile.toggleState();
        expect(tile.state).toBe('closed');
    });

    it('should toggle rotation if rotations exist', () => {
        const tile = new Tile('wall');
        expect(tile.orientation).toBe('Horizontal');
        tile.toggleRotation();
        expect(tile.orientation).toBe('Vertical');
        tile.toggleRotation();
        expect(tile.orientation).toBe('Horizontal');
    });

    it('should update imagePath and moveModifier correctly', () => {
        const tile = new Tile('snow');
        expect(tile.imagePath).toBeDefined();
        expect(tile.moveModifier).toBe(TILE_TYPES['snow'].baseMoveModifier);
    });

    it('should use default image when variantProbability is undefined', () => {
        const originalVariantProbability = TILE_TYPES['snow'].variantProbability;
        delete TILE_TYPES['snow'].variantProbability;
        const tile = new Tile('snow');
        expect(tile.imagePath).toBe(TILE_TYPES['snow'].images.default);
        TILE_TYPES['snow'].variantProbability = originalVariantProbability;
    });

    it('should remove diagonal suffix from image path if not found', () => {
        const tile = new Tile('water', 'defaultUpDownLeft_BL');
        tile['updateProperties']();
        expect(tile.imagePath).toBe(TILE_TYPES['water'].images.default);
    });
});
