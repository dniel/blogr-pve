node('master') {
    currentBuild.result = "SUCCESS"

    ansiColor('xterm') {
        stage('Prepare') {
            mattermostSend "${env.JOB_NAME} - ${env.BUILD_NUMBER} started."
            checkout scm
        }

        stage("Puppet Apply") {
            try {
                /**
                 * Retrieve Nodes from Consul HTTP API.
                 * https://www.consul.io/docs/agent/http.html
                 */
                def response = httpRequest "http://consul.service.consul:8500/v1/catalog/nodes"

                def nodes = parseJsonText response.content
                for (node in nodes) {
                    if (!node.Node.contains('p-ci-01')) {
                        mattermostSend color: "good", message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} Update ${node.Node} , ${node.Address}"
                        puppetApply node.Address
                    }
                }
                mattermostSend color: "good", message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} ${nodes.size} nodes was updated."
            } catch (err) {
                currentBuild.result = "FAILURE"
                mattermostSend color: "bad", message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} FAILED."
                throw err
            }
        }
        stage('Jenkins') {
            sh 'git --work-tree=/opt/puppet/pve --git-dir=/opt/puppet/pve/.git pull'
            sh 'sudo /opt/puppet/pve/apply.sh'
            mattermostSend color: "good", message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} Build server was updated."
        }
    }
}

/**
 * Use serializable version of JsonSlurper that
 * use response objects that are serializable.
 * @param json text
 * @return json objects
 */
@NonCPS
def parseJsonText(String json) {
    new groovy.json.JsonSlurperClassic().parseText(json)
}

def puppetApply(server) {
    print "Update ${server}"
    sh "rsync -az --delete -e \"ssh -o StrictHostKeyChecking=no\" jenkins@${server}:/opt/puppet/ /opt/puppet"
    sh "ssh -o StrictHostKeyChecking=no jenkins@${server} 'sudo /opt/puppet/pve/apply.sh'"
}
