import { Component, EventEmitter, Input, Output } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Board } from '@app/classes/board/board';
import { MapGeneratorService } from '@app/services/editor/map-generator.service';
import { GameService } from '@app/services/editor/game.service';
import { ItemService } from '@app/services/editor/item.service';
import { TeleportService } from '@app/services/editor/teleport.service';
import { DEFAULT_WATER_PERCENT, DEFAULT_ICE_PERCENT, MAX_WATER_PERCENT, MAX_ICE_PERCENT } from '@app/constants/map-generator.constants';
import { TranslateModule } from '@ngx-translate/core';

@Component({
    selector: 'app-generate-map',
    imports: [FormsModule, TranslateModule],
    templateUrl: './generate-map.component.html',
    styleUrl: './generate-map.component.scss',
})
export class GenerateMapComponent {
    @Input() board!: Board;
    @Output() mapGenerated = new EventEmitter<void>();

    isDialogOpen = false;
    waterPercent = DEFAULT_WATER_PERCENT;
    icePercent = DEFAULT_ICE_PERCENT;

    readonly maxWaterPercent = MAX_WATER_PERCENT;
    readonly maxIcePercent = MAX_ICE_PERCENT;

    constructor(
        private mapGeneratorService: MapGeneratorService,
        private gameService: GameService,
        private itemService: ItemService,
        private teleportService: TeleportService,
    ) {}

    onOpenDialog(): void {
        this.isDialogOpen = true;
    }

    onCancel(): void {
        this.isDialogOpen = false;
    }

    onGenerate(): void {
        const mode = this.gameService.getMode();
        this.mapGeneratorService.generate(this.board, mode, this.waterPercent, this.icePercent);
        this.itemService.setItemCountFromBoard(this.board);
        this.teleportService.initializePairsFromBoard(this.board);
        this.isDialogOpen = false;
        this.mapGenerated.emit();
    }
}
