FROM iamdevopstrainer/tomcat:base
COPY abc.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]


pipeline 
{
    agent any
    stages
    {
        stage('Code Checkout') 
        {
            steps 
            {
                git 'https://github.com/Surya050400/igp.git'
            }
        }

        stage('Code Compile') 
        {
            steps 
            {
                sh 'mvn compile'
            }
        }

        stage('Test') 
        {
            steps 
            {
                sh 'mvn test'
            }
        }

        stage('Build') 
        {
            steps 
            {
                sh 'mvn package'
            }
        }

        stage('Build Docker Image') 
        {
            steps 
            {
                sh 'cp /var/lib/jenkins/workspace/$JOB_NAME/target/ABCtechnologies-1.0.war /var/lib/jenkins/workspace/$JOB_NAME/abc.war'
                sh 'docker build -t Surya050400/abc_tech:$BUILD_NUMBER .'
            }
        }

        stage('Push Docker Image') 
        {
            steps 
            {
                withDockerRegistry([ credentialsId: "mydockerhub", url: "" ]) 
                {
                    sh 'docker build -t Surya050400/abc_tech:$BUILD_NUMBER .'
                }
            }
        }

        stage('Deploy as container') 
        {
            steps 
            {
                sh 'docker run -itd -P Surya050400/abc_tech:$BUILD_NUMBER'
            }
        }
    }
}
