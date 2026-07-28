import os
from unittest.mock import patch
from psycopg2 import OperationalError as Psycopg2Error  # type: ignore
from django.core.management import call_command
from django.db.utils import OperationalError
from django.test import SimpleTestCase


@patch('core.management.commands.wait_for_db.Command.check')
class CommandTest(SimpleTestCase):
    # Test Commands

    def test_wait_for_db_ready(self, patched_check):
        # Test waiting for database to be ready
        patched_check.return_value = True
        call_command('wait_for_db')
        patched_check.assert_called_once_with(databases=['default'])

    @patch('time.sleep')
    def test_wait_for_db_delay(self, patched_sleep, patched_check):
        # Test waiting to database when get OperationalError
        patched_check.side_effect = [Psycopg2Error] * 2 + \
            [OperationalError] * 3 + [True]
        call_command('wait_for_db')
        self.assertEqual(patched_check.call_count, 6)
        patched_check.assert_called_with(databases=['default'])


@patch('core.management.commands.wait_for_redis.Redis')
class RedisCommandTest(SimpleTestCase):
    # Test wait_for_redis command

    def test_wait_for_redis_ready(self, patched_redis):
        # Test waiting for Redis to be ready
        mock_client = patched_redis.return_value
        mock_client.ping.return_value = True

        call_command('wait_for_redis')

        expected_host = os.environ.get('REDIS_HOST', 'localhost')
        patched_redis.assert_called_once_with(host=expected_host, port=6379)
        mock_client.ping.assert_called_once()

    @patch('time.sleep')
    def test_wait_for_redis_delay(self, patched_sleep, patched_redis):
        # Test waiting for Redis when ConnectionError is raised
        mock_client = patched_redis.return_value
        from redis.exceptions import ConnectionError as RedisConnectionError
        mock_client.ping.side_effect = [RedisConnectionError] * 3 + [True]

        call_command('wait_for_redis')

        self.assertEqual(mock_client.ping.call_count, 4)
        expected_host = os.environ.get('REDIS_HOST', 'localhost')
        patched_redis.assert_called_with(host=expected_host, port=6379)

