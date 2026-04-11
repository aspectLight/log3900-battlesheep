import { Module, forwardRef } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthModule } from '@app/modules/auth/auth.module';
import { FriendRequest, FriendRequestSchema } from './schemas/friend-request.schema';
import { Friendship, FriendshipSchema } from './schemas/friendship.schema';
import { Block, BlockSchema } from './schemas/block.schema';
import { FriendshipService } from './services/friendship.service';
import { BlockService } from './services/block.service';
import { SocialController } from './controllers/social.controller';
import { SocialGateway } from './gateways/social.gateway';
import { User, UserSchema } from '@app/modules/auth/schemas/user.schema';

@Module({
    imports: [
        MongooseModule.forFeature([
            { name: FriendRequest.name, schema: FriendRequestSchema },
            { name: Friendship.name, schema: FriendshipSchema },
            { name: Block.name, schema: BlockSchema },
            { name: User.name, schema: UserSchema },
        ]),
        forwardRef(() => AuthModule),
    ],
    controllers: [SocialController],
    providers: [FriendshipService, BlockService, SocialGateway],
    exports: [FriendshipService, BlockService, SocialGateway],
})
export class SocialModule {}
