import { Injectable } from '@angular/core';
import { ShopItem } from '@common/shop.constants';
import { CurrencyEvents } from '@common/socket.constants';
import { BehaviorSubject, Observable } from 'rxjs';
import { SocketService } from '../communication/socket-handlers/socket.service';

@Injectable({
    providedIn: 'root',
})
export class VirtualCurrencyService {
    private balanceSubject = new BehaviorSubject<number>(0);
    private purchasedItemsSubject = new BehaviorSubject<string[]>([]);
    private catalogueSubject = new BehaviorSubject<ShopItem[]>([]);

    balance$: Observable<number> = this.balanceSubject.asObservable();
    purchasedItems$: Observable<string[]> = this.purchasedItemsSubject.asObservable();
    catalogue$: Observable<ShopItem[]> = this.catalogueSubject.asObservable();

    get balance(): number {
        return this.balanceSubject.getValue();
    }

    get purchasedItems(): string[] {
        return this.purchasedItemsSubject.getValue();
    }

    get catalogue(): ShopItem[] {
        return this.catalogueSubject.getValue();
    }

    constructor(private socketService: SocketService) {}

    setupListeners(): void {
        this.socketService.on(CurrencyEvents.VirtualCurrencyUpdated, (data: { balance: number }) => {
            this.balanceSubject.next(data.balance);
        });

        this.socketService.on(CurrencyEvents.VirtualCurrencyResponse, (data: { success: boolean; balance?: number }) => {
            if (data.success && data.balance !== undefined) {
                this.balanceSubject.next(data.balance);
            }
        });

        this.socketService.on(
            CurrencyEvents.ShopCatalogResponse,
            (data: { success: boolean; catalogue?: ShopItem[]; purchasedItems?: string[] }) => {
                if (data.success) {
                    if (data.catalogue) this.catalogueSubject.next(data.catalogue);
                    if (data.purchasedItems) this.purchasedItemsSubject.next(data.purchasedItems);
                }
            },
        );

        this.socketService.on(
            CurrencyEvents.PurchaseItemResponse,
            (data: { success: boolean; newBalance?: number; purchasedItems?: string[] }) => {
                if (data.success) {
                    if (data.newBalance !== undefined) this.balanceSubject.next(data.newBalance);
                    if (data.purchasedItems) this.purchasedItemsSubject.next(data.purchasedItems);
                }
            },
        );
    }

    fetchBalance(): void {
        this.socketService.send(CurrencyEvents.GetVirtualCurrency, undefined);
    }

    fetchCatalogue(): void {
        this.socketService.send(CurrencyEvents.GetShopCatalog, undefined);
    }

    purchaseItem(itemId: string): void {
        this.socketService.send(CurrencyEvents.PurchaseItem, { itemId });
    }

    hasPurchased(itemId: string): boolean {
        return this.purchasedItemsSubject.getValue().includes(itemId);
    }
}
