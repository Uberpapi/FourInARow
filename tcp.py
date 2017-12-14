import socket
import time

serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
serversocket.bind(('localhost', 4000))
serversocket.listen(5) # become a server socket, maximum 5 connections
start_time = time.time()
print('Server started')
while True:
    connection, address = serversocket.accept()
    buf = connection.recv(1024)
    print(time.time() - start_time)
    print (buf)
    if buf == 'q' or buf == 'Q':
        break
