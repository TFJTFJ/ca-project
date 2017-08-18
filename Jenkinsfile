node('master') {
    stage('git'){
        git credentialsId: '37d68ced-553a-4381-a258-637f54af1239', url: 'git@github.com:TFJTFJ/ca-project.git'
        stash includes :"**", name: 'source'
    }
    
    stage('Run tests'){
        unstash 'source'
         sh 'docker build -t codeconfimg .'
         sh 'docker run --rm --name codeconf -v "$PWD":/usr/src/app -w /usr/src/app/ codeconfimg py.test --junitxml results.xml tests.py'
         stash includes: "results.xml", name:'testresults'
    }   
    
    def builders = [
        "Stage app": {
            node{
            unstash 'source'
            sh 'docker build -t codeconfimg .'
            sh 'docker run -d --rm --name codeconf -p 5000:5000 -w /usr/src/app/ codeconfimg /usr/src/app/run.sh'
            }
        },
        
        "Report test results": {
            node{
                unstash 'testresults'
                 junit 'results.xml'
            }
        }
    ]
    
    stage('Post-build'){
        parallel builders
    }

    stage('Accept staged app'){
        input 'Accept staged application into deployment'
        sh 'docker stop codeconf'
    
    }    
    
    stage('Deploy app')
    {
        withDockerRegistry([credentialsId: '13e1dadb-6019-4804-aeb5-a0b996acff18']) {
            sh 'docker tag codeconfimg emilmunksoe/codeconfimg:latest'
            sh 'docker push emilmunksoe/codeconfimg'
        }
    }
    
    stage('Nuke from low orbit'){
        try{
            sh 'docker rmi codeconfimg'
            sh 'docker rm $(docker ps -a -q)'
        } catch (Exception e) {
            
        }
    }
}
