pipeline {
    agent any
    environment {
        REGISTRY = "cr.yandex/crps7usnpsm729ptcit7"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build & Push') {
            steps {
                script {
                    def services = [
                        "frontend",
                        "adservice",
                        "cartservice",
                        "checkoutservice",
                        "currencyservice",
                        "emailservice",
                        "paymentservice",
                        "productcatalogservice",
                        "recommendationservice",
                        "shippingservice",
                        "shoppingassistantservice"
                    ]
                    def builds = [:]
                    for(service in services){
                        builds[service] = {
                            dir("src/${service}"){
                                sh """
                                docker build \
                                -t ${REGISTRY}/${service}:${IMAGE_TAG} .
                                docker push \
                                ${REGISTRY}/${service}:${IMAGE_TAG}
                                """
                            }
                        }
                    }
                    parallel builds
                }
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([
                    file(credentialsId: 'kubeconfig',
                        variable: 'KUBECONFIG')
                    ]) {
                    sh """
                    helm upgrade \
                    --install boutique \
                    helm-chart \
                    --namespace boutique \
                    --set images.tag=${IMAGE_TAG}
                    """
                }
            }
        }
        stage('Rollout') {
            steps {
                withCredentials([
                    file(credentialsId: 'kubeconfig',
                        variable: 'KUBECONFIG')
                    ]) {
                    sh """
                    kubectl rollout status deployment/frontend -n boutique
                    """
                }
            }
        }
    }
}