github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
#del_version=$(cat delete_version.txt)

if [ $github_version != $ftp_version ]
then
    cd $GOPATH/src/github.com
    mkdir grafana
    cd grafana
    wget https://github.com/grafana/grafana/archive/v$github_version.zip
    unzip v$github_version.zip
    mv grafana-$github_version grafana
    cd grafana
    ls
    make
    make test
    ls
    #cd ./bin/linux-ppc64le/
    #ls
    #mv grafana-server grafana-$github_version-server
    #mv grafana-cli grafana-$github_version-cli
    #./grafana-$github_version-cli
    #./grafana-$github_version-server --help
    #pwd
    #if [ $github_version > $ftp_version ]
    #then
    #  lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/grafana/ /var/lib/jenkins/workspace/grafana-releases/grafana/grafana/bin/linux-ppc64le/grafana-$github_version-server"
    #  lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/grafana/ /var/lib/jenkins/workspace/grafana-releases/grafana/grafana/bin/linux-ppc64le/grafana-$github_version-cli" 
    #fi
fi
