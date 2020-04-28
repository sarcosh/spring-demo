import urllib
from xml.dom import minidom

webf = urllib.urlopen('http://openshift43.ddns.net:8080/nexus/repository/spring-demo-snapshot/com/seat/demo/spring-demo/0.0.1-SNAPSHOT/maven-metadata.xml')

metadataFile = minidom.parse(webf)


artifactId = metadataFile.getElementsByTagName('artifactId')

if len(artifactId) > 0:
	appName = artifactId[0].firstChild.data

value = metadataFile.getElementsByTagName('value')

if len(value) > 0:
	print(appName + "-" + value[0].firstChild.data + ".war")


