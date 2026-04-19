import logging
import logging.config

logging.config.dictConfig({
    'version': 1,
    'formatters': {
        'default': {
            'format': '[%(asctime)s] %(levelname)s in %(module)s: %(message)s',
        }
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'stream': 'ext://sys.stdout',
            'formatter': 'default'
        },
        'file': {
            'class': 'logging.FileHandler',
            'filename': 'app.log',
            'formatter': 'default'
        }
    },
    'root': {
        'level': 'DEBUG',
        'handlers': ['console', 'file']
    }
})

logger = logging.getLogger(__name__)

class App:
    def __init__(self):
        self.logger = logger

    def run(self):
        self.logger.debug('App is running')
        self.logger.info('App info')
        self.logger.warning('App warning')
        self.logger.error('App error')
        self.logger.critical('App critical')

app = App()
app.run()

try:
    x = 1 / 0
except ZeroDivisionError:
    logger.exception('Exception occurred')

logger.debug('Debug message')
logger.info('Info message')
logger.warning('Warning message')
logger.error('Error message')
logger.critical('Critical message')

class AnotherClass:
    def __init__(self):
        self.logger = logger

    def another_method(self):
        self.logger.debug('Another method debug')
        self.logger.info('Another method info')
        self.logger.warning('Another method warning')
        self.logger.error('Another method error')
        self.logger.critical('Another method critical')

another_class = AnotherClass()
another_class.another_method()