import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { RouterLink } from '@angular/router';
import { ProfileMenuComponent } from '@app/components/shared/profile-menu/profile-menu.component';
import { PopUpComponent } from '@app/components/shared/pop-up/pop-up.component';
import { ShopItem } from '@common/shop.constants';
import { VirtualCurrencyService } from '@app/services/currency/virtual-currency.service';
import { ProfileService } from '@app/services/communication/profile.service';

@Component({
    selector: 'app-shop-page',
    templateUrl: './shop-page.component.html',
    styleUrl: './shop-page.component.scss',
    imports: [CommonModule, RouterLink, ProfileMenuComponent, PopUpComponent],
})
export class ShopPageComponent implements OnInit {
    purchaseSuccess: string = '';
    showInsufficientFundsPopup: boolean = false;
    activePreferences: Record<string, string> = {};

    constructor(
        public currencyService: VirtualCurrencyService,
        private profileService: ProfileService,
    ) {}

    async ngOnInit(): Promise<void> {
        this.currencyService.fetchBalance();
        this.currencyService.fetchCatalogue();
        try {
            const profile = await this.profileService.getProfile();
            this.activePreferences = (profile.preferences as Record<string, string>) ?? {};
        } catch {
            // continue with empty preferences
        }
    }

    get avatars(): ShopItem[] {
        return this.currencyService.catalogue.filter((i) => i.type === 'avatar');
    }

    get banners(): ShopItem[] {
        return this.currencyService.catalogue.filter((i) => i.type === 'banner');
    }

    get characters(): ShopItem[] {
        return this.currencyService.catalogue.filter((i) => i.type === 'character');
    }

    requestPurchase(item: ShopItem): void {
        if (this.currencyService.hasPurchased(item.id)) return;
        if (this.currencyService.balance < item.price) {
            this.showInsufficientFundsPopup = true;
            return;
        }
        this.currencyService.purchaseItem(item.id);
        this.purchaseSuccess = 'Achat effectué !';
        setTimeout(() => { this.purchaseSuccess = ''; }, 3000);
    }

    isEquipped(item: ShopItem): boolean {
        const key = item.type === 'banner' ? 'activeBanner' : null;
        return key ? this.activePreferences[key] === item.id : false;
    }

    async toggleEquip(item: ShopItem): Promise<void> {
        const key = item.type === 'banner' ? 'activeBanner' : null;
        if (!key) return;

        const newValue = this.isEquipped(item) ? null : item.id;
        const prefs: Record<string, unknown> = { ...this.activePreferences, [key]: newValue };
        await this.profileService.updateProfile({ preferences: prefs });
        if (newValue) {
            this.activePreferences = { ...this.activePreferences, [key]: newValue };
        } else {
            const updated = { ...this.activePreferences };
            delete updated[key];
            this.activePreferences = updated;
        }
        this.purchaseSuccess = newValue ? 'Cosmétique équipé !' : 'Cosmétique déséquipé.';
        setTimeout(() => { this.purchaseSuccess = ''; }, 3000);
    }
}
