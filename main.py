import logging
import random 
# Basic configuration to write to 'app.log'

for i in range(200):
    logging.basicConfig(filename='app.log', level=logging.DEBUG,
                    format='%(asctime)s - %(levelname)s - %(message)s')

    case = random.choice(['debug', 'info', 'warning'])
    if case == 'debug':
        logging.debug(f'This is debug message {i}')
    elif case == 'info':    
        logging.info(f'This is info message {i}')
    else:
        logging.warning(f'This is warning message {i}')


