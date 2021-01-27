github_version=$(cat github_version.txt)
github_version=v7.4.0-beta1
ftp_version=$(cat ftp_version.txt)
#del_version=$(cat delete_version.txt)

if [ $github_version != $ftp_version ]
then
    wget https://github.com/grafana/grafana/archive/v$github_version.zip
    unzip v$github_version.zip
    mv grafana-$github_version grafana
    cd grafana
    make
    cd bin/linux-ppc64le/
    mv grafana-server grafana-$github_version-server
    mv grafana-cli grafana-$github_version-cli
    ./grafana-$github_version-cli --version
    ./grafana-$github_version-server -v
    pwd
    if [ $github_version > $ftp_version ]
    then
      lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/grafana/ /var/lib/jenkins/workspace/grafana-releases/grafana/bin/linux-ppc64le/grafana-$github_version-server"
      lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/grafana/ /var/lib/jenkins/workspace/grafana-releases/grafana/bin/linux-ppc64le/grafana-$github_version-cli"
    fi
fi
