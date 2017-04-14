currentBuild.result = "SUCCESS"

ansiColor('xterm') {
    stage("Puppet Apply") {
        node('master') {
            mattermostSend "${env.JOB_NAME} - ${env.BUILD_NUMBER} started."
            checkout scm
            sh 'git --work-tree=/opt/puppet/pve --git-dir=/opt/puppet/pve/.git pull'
            sh 'sudo /opt/puppet/pve/apply.sh'
            mattermostSend color: "good", message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} Build server was updated."
        }
        node('master') {
            try {
                /**
                 * Retrieve Nodes from Consul HTTP API.
                 * https://www.consul.io/docs/agent/http.html
                 */
                def response = httpRequest "http://consul.service.consul:8500/v1/catalog/nodes"
                def nodesJson = parseJsonText response.content
                def nodes = [:]
                for (int i = 0; i < nodesJson.size(); i++) {
                    def node = nodesJson[i];
                    nodes["node${i}"] = {
                        // retrieve status of serfHealth to check if node is online.
                        response = httpRequest "http://consul.service.consul:8500/v1/health/node/${node.Node}"
                        status = parseHealthCheck response

                        if (!node.Node.contains('p-ci-01') && status == "passing") {
                            mattermostSend color: "good", message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} Update ${node.Node} , ${node.Address}"
                            puppetApply node.Address
                        } else {
                            mattermostSend color: "good", message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} Ignore update ${node.Node} , ${node.Address}"
                        }
                    }
                }
                parallel nodes
                mattermostSend color: "good", message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} ${nodes.size} nodes was updated."
            } catch (err) {
                currentBuild.result = "FAILURE"
                mattermostSend color: "bad", message: "${env.JOB_NAME} - ${env.BUILD_NUMBER} FAILED."
                throw err
            }
        }
    }
}

@NonCPS
def parseHealthCheck(response) {
    def health = parseJsonText response.content
    for (int i = 0; i < health.size; i++) {
        if (health[i].CheckID == 'serfHealth') return health[i].Status;
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

/**
 * Checkout latest version of puppet scripts from GITHUB and run apply.sh
 * @param server
 * @return
 */
def puppetApply(server) {
    print "Update ${server}"
    sh "ssh -o StrictHostKeyChecking=no jenkins@${server} 'git --work-tree=/opt/puppet/pve --git-dir=/opt/puppet/pve/.git pull'"
    sh "ssh -o StrictHostKeyChecking=no jenkins@${server} 'sudo /opt/puppet/pve/apply.sh'"
}