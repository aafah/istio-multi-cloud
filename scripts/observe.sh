pattern="proxy_pass http://kiali.app.cube"

if [ $1 -eq 1 ]; then
    if [[ " $* " == *" --clear "* ]]; then
        kubectl delete -f ../istio-1.17.2/samples/addons/prometheus.yaml --context=cube2
        kubectl delete -f ../istio-1.17.2/samples/addons/kiali.yaml --context=cube2
    fi

    new_conf="proxy_pass http://kiali.app.cube1:20001;"
    kubectl apply -f ../istio-1.17.2/samples/addons/prometheus.yaml --context=cube1
    kubectl apply -f ../istio-1.17.2/samples/addons/kiali.yaml --context=cube1

else
    if [[ " $* " == *" --clear "* ]]; then
        kubectl delete -f ../istio-1.17.2/samples/addons/prometheus.yaml --context=cube1
        kubectl delete -f ../istio-1.17.2/samples/addons/kiali.yaml --context=cube1
    fi
    
    new_conf="proxy_pass http://kiali.app.cube2:20001;"
    kubectl apply -f ../istio-1.17.2/samples/addons/prometheus.yaml --context=cube2
    kubectl apply -f ../istio-1.17.2/samples/addons/kiali.yaml --context=cube2
    
fi

sudo sed -i "s@$pattern.*@$new_conf@" /etc/nginx/sites-available/default
sudo systemctl reload nginx

sleep 5
