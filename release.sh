#!/usr/bin/env bash
github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
LOCALPATH=/var/lib/jenkins/workspace/grafana-releases
BINPATH=/var/lib/jenkins/workspace/grafana-releases/grafana/bin/linux-ppc64le

if [ $github_version != $ftp_version ]
then
  cd $LOCALPATH
  git clone https://$USERNAME:$TOKEN@github.com/Unicamp-OpenPower/repository-scrips.git
  cd repository-scrips/
  chmod +x empacotar-deb.sh
  chmod +x empacotar-rpm.sh
  mv empacotar-deb.sh $BINPATH
  mv empacotar-rpm.sh $BINPATH
  cd $BINPATH
  ./empacotar-deb.sh grafana-cli grafana-$github_version-cli $github_version " "
  ./empacotar-deb.sh grafana-server grafana-$github_version-server $github_version " "
  sudo su
  ./empacotar-rpm.sh grafana-cli grafana-$github_version-cli $github_version " " "The tool for beautiful monitoring and metric analytics & dashboards for Graphite, InfluxDB & Prometheus & More"
  ./empacotar-rpm.sh grafana-server grafana-$github_version-server $github_version " " "The tool for beautiful monitoring and metric analytics & dashboards for Graphite, InfluxDB & Prometheus & More"
  if [ $github_version > $ftp_version ]
  then
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /repository/debian/ppc64el/grafana/ /var/lib/jenkins/workspace/grafana-releases/grafana/bin/linux-ppc64le/grafana-cli-$github_version-ppc64le.deb"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /repository/debian/ppc64el/grafana/ /var/lib/jenkins/workspace/grafana-releases/grafana/bin/linux-ppc64le/grafana-server-$github_version-ppc64le.deb"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /repository/rpm/ppc64le/grafana/ /root/rpmbuild/RPMS/ppc64le/grafana-cli-$github_version-1.ppc64le.rpm"
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /repository/rpm/ppc64le/grafana/ /root/rpmbuild/RPMS/ppc64le/grafana-server-$github_version-1.ppc64le.rpm"
  fi
fi
