import nexus

def main():

 urlNexusRepository = "http://openshift43.ddns.net:8080/nexus/repository"
 repositoryName = "spring-demo-snapshot"

 groupId = "com.seat.demo"
 artifactId = "spring-demo"
 version = "0.0.1"

 lastVersion = nexus.getLastVersion(urlNexusRepository, repositoryName, groupId, artifactId, version)

 nexus.download_file_from_url(urlNexusRepository, repositoryName, groupId, artifactId, version, lastVersion, "/Users/sarcosh/Documents/TEMP")

main()







