python3 -m pip3 install virtualenv
python3 -m virtualenv ServerDevelopment
source ServerDevelopment/bin/activate
pip3 install -r requirements.txt --no-cache-dir
echo "Packages installed successfully." 
TARGET='darwin'
if [[ $OSTYPE == "$TARGET"* ]]; then
    export PATH="$PATH":"$PWD/ServerDevelopment/bin"
else
    export PATH="$PATH":"$PWD\ServerDevelopment\bin"
fi
python3 manage.py runserver