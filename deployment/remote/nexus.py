import urllib
import urllib2
from xml.dom import minidom

def getLastVersionFromURL(url):
 webf = urllib.urlopen(url)
 metadataFile = minidom.parse(webf)
 artifactId = metadataFile.getElementsByTagName('artifactId')

 if len(artifactId) > 0:
  appName = artifactId[0].firstChild.data

 value = metadataFile.getElementsByTagName('value')

 if len(value) > 0:
  print(appName + "-" + value[0].firstChild.data + ".war")
  return appName + "-" + value[0].firstChild.data + ".war"

def getLastVersion(urlNexusRepository, repositoryName, groupId, artifactId, version):
	url = urlNexusRepository + "/" + repositoryName + "/" + groupId.replace(".","/") + "/" + artifactId + "/" + version + "-SNAPSHOT" + "/maven-metadata.xml"
	lastversion = getLastVersionFromURL(url)
	return lastversion

def download_file_from_url(urlNexusRepository, repositoryName, groupId, artifactId, version, lv, save_path):
 url = urlNexusRepository + "/" + repositoryName + "/" + groupId.replace(".","/") + "/" + artifactId + "/" + version + "-SNAPSHOT" + "/" + lv
 filedata = urllib2.urlopen(url)
 datatowrite = filedata.read()

 print("Downloading file...")
 with open(save_path + "/" + artifactId + ".zip", 'wb') as f:
  f.write(datatowrite)