from urllib.parse import parse_qs
from channels.db import database_sync_to_async
from django.contrib.auth.models import AnonymousUser
from rest_framework.authtoken.models import Token
from channels.middleware import BaseMiddleware

@database_sync_to_async
def get_user(token_key):
    try:
        token = Token.objects.get(key=token_key)
        return token.user
    except Token.DoesNotExist:
        return AnonymousUser()

class TokenAuthMiddleware(BaseMiddleware):
    async def __call__(self, scope, receive, send):
        query_string = scope.get('query_string', b'').decode('utf-8')
        query_params = parse_qs(query_string)
        token = query_params.get('token')
        
        if not token:
            # check headers
            headers = dict(scope.get('headers', []))
            if b'authorization' in headers:
                auth_header = headers[b'authorization'].decode('utf-8')
                if auth_header.startswith('Token '):
                    token = [auth_header.split('Token ')[1]]

        if token:
            user = await get_user(token[0])
            scope['user'] = user
        elif 'user' not in scope:
            scope['user'] = AnonymousUser()
            
        return await super().__call__(scope, receive, send)
