"""
Django command to wait for Redis to be available
"""
import time
import os
from redis import Redis
from redis.exceptions import ConnectionError as RedisConnectionError
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    """Django command to wait for Redis"""

    def handle(self, *args, **options):
        # Entry point for command
        self.stdout.write('Waiting for Redis...')
        redis_host = os.environ.get('REDIS_HOST', 'localhost')
        redis_up = False
        while redis_up is False:
            try:
                # Attempt to connect to Redis
                client = Redis(host=redis_host, port=6379)
                client.ping()
                redis_up = True
            except RedisConnectionError:
                self.stdout.write('Redis unavailable, waiting 1 second...')
                time.sleep(1)
        self.stdout.write(self.style.SUCCESS('Redis available!'))
