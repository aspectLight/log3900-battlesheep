/* eslint-disable @typescript-eslint/naming-convention */
import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { UserDocument } from '@app/modules/auth/schemas/user.schema';

export const CurrentUser = createParamDecorator((data: keyof UserDocument | undefined, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    const user = request.user as UserDocument;
    return data ? user?.[data] : user;
});
