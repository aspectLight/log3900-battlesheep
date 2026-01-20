import { Tile } from '@app/classes/board/tile';
import { Entity } from '@app/classes/entity/entity';
import { Item } from '@app/classes/entity/item';
import { Player } from '@app/classes/entity/player';

export class Cell {
    item: Item | null = null;
    player: Player | null = null;
    tile: Tile;
    x: number;
    y: number;

    hasPathUp = false;
    hasPathDown = false;
    hasPathLeft = false;
    hasPathRight = false;

    constructor(tile: Tile, x: number, y: number) {
        this.tile = tile;
        this.x = x;
        this.y = y;
    }

    static fromObject(obj: Cell): Cell {
        const cell = new Cell(obj.tile, obj.x, obj.y);

        cell.hasPathUp = obj.hasPathUp;
        cell.hasPathDown = obj.hasPathDown;
        cell.hasPathLeft = obj.hasPathLeft;
        cell.hasPathRight = obj.hasPathRight;

        cell.item = obj.item ? new Item(obj.item.type) : null;
        cell.player = obj.player ? Player.fromObject(obj.player) : null;
        return cell;
    }

    getItem(): Item | null {
        return this.item;
    }

    addItem(item: Item) {
        this.item = new Item(item.type);
    }

    removeItem() {
        this.item = null;
    }

    getEntity(): Entity | null {
        return this.player;
    }

    addEntity(player: Player) {
        this.player = player;
    }

    removeEntity() {
        this.player = null;
    }
}
