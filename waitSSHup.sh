echo "Waiting for sshd established (it takes few minutes)..."
while ! ssh -oStrictHostKeyChecking=no -o ConnectTimeout=5 -p "cygwin" Administrator@localhost echo "ssh ready!"
do
    echo "Trying again..."
    sleep 3
done