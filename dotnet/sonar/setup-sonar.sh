apk add --no-cache --update openjdk8-jre nss
dotnet tool install --global dotnet-sonarscanner
export PATH=${PATH}:/root/.dotnet/tools
dotnet sonarscanner begin /k:"${CI_PROJECT_PATH_SLUG}"  /d:sonar.host.url="${SONAR_HOST_URL}" /d:sonar.language="cs" /d:sonar.exclusions="**/bin/**/*,**/obj/**/*" /d:sonar.login="${SONAR_LOGIN}"  /d:sonar.cs.opencover.reportsPaths="${PROJECT_TEST_PATH}/coverage.opencover.xml" /d:sonar.coverage.exclusions="**Test*.cs"
dotnet restore --configfile ${PROJECT_API_PATH}/nuget.config ${PROJECT_API_PATH}
dotnet restore --configfile ${PROJECT_TEST_PATH}/nuget.config ${PROJECT_TEST_PATH}
dotnet build ${PROJECT_SLN_PATH}
dotnet test ${PROJECT_TEST_PATH} /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
dotnet sonarscanner end /d:sonar.login=${SONAR_LOGIN}
