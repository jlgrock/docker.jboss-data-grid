#!groovy

node() {

    try {

        stage('Checkout'){

          checkout scm
       }

        stage('Build RHJDG') {
          echo 'Building..'
          sh 'eval $(aws ecr get-login --no-include-email --region us-east-1)'
          sh '. ./build.sh'
        }
        stage('Publish RHJDG') {
          echo 'Publishing Image..'
          sh '. ./publish.sh'
        }
    }
    catch (err) {

      throw err
    }
}
