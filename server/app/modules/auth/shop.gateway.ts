import { AuthService } from '@app/modules/auth/services/auth.service';
import { SHOP_CATALOGUE } from '@common/shop.constants';
import { CurrencyEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import { ConnectedSocket, MessageBody, OnGatewayInit, SubscribeMessage, WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';

@Injectable()
@WebSocketGateway({ cors: { origin: '*' } })
export class ShopGateway implements OnGatewayInit {
    @WebSocketServer() server: Server;
    private readonly logger = new Logger(ShopGateway.name);

    constructor(private readonly authService: AuthService) {}

    afterInit() {
        this.logger.log('ShopGateway initialized');
    }

    @SubscribeMessage(CurrencyEvents.GetVirtualCurrency)
    async handleGetVirtualCurrency(@ConnectedSocket() socket: Socket): Promise<void> {
        try {
            const uid = await this.resolveFirebaseUid(socket);
            if (!uid) {
                socket.emit(CurrencyEvents.VirtualCurrencyResponse, { success: false, error: 'Non authentifié' });
                return;
            }
            const balance = await this.authService.getVirtualCurrency(uid);
            socket.emit(CurrencyEvents.VirtualCurrencyResponse, { success: true, balance });
        } catch (error) {
            socket.emit(CurrencyEvents.VirtualCurrencyResponse, { success: false, error: error.message });
        }
    }

    @SubscribeMessage(CurrencyEvents.GetShopCatalog)
    async handleGetShopCatalog(@ConnectedSocket() socket: Socket): Promise<void> {
        try {
            const uid = await this.resolveFirebaseUid(socket);
            const purchasedItems = uid ? await this.authService.getPurchasedItems(uid) : [];
            socket.emit(CurrencyEvents.ShopCatalogResponse, { success: true, catalogue: SHOP_CATALOGUE, purchasedItems });
        } catch (error) {
            socket.emit(CurrencyEvents.ShopCatalogResponse, { success: false, error: error.message });
        }
    }

    @SubscribeMessage(CurrencyEvents.PurchaseItem)
    async handlePurchaseItem(@ConnectedSocket() socket: Socket, @MessageBody() data: { itemId: string }): Promise<void> {
        try {
            const uid = await this.resolveFirebaseUid(socket);
            if (!uid) {
                socket.emit(CurrencyEvents.PurchaseItemResponse, { success: false, error: 'Non authentifié' });
                return;
            }
            const result = await this.authService.purchaseItem(uid, data.itemId);
            socket.emit(CurrencyEvents.PurchaseItemResponse, { success: true, ...result });
            socket.emit(CurrencyEvents.VirtualCurrencyUpdated, { balance: result.newBalance });
        } catch (error) {
            socket.emit(CurrencyEvents.PurchaseItemResponse, { success: false, error: error.message });
        }
    }

    private async resolveFirebaseUid(socket: Socket): Promise<string | null> {
        try {
            const { token } = socket.handshake.auth as { token?: string };
            if (!token) return null;
            const decoded = await this.authService.verifyToken(token);
            return decoded.uid ?? null;
        } catch {
            return null;
        }
    }
}
