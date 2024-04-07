function estnodes=estimateLocationsInAllClusters(nodes,obs,clusters)

    estnodes=nodes;
    for i=1:size(clusters,1)
        cluster=clusters{i};
        clusterestnodes=estimateLocationsInCluster(nodes,obs,cluster);
        for j=1:length(cluster)
            estnodes(cluster(j),1)=clusterestnodes(j,1);
            estnodes(cluster(j),2)=clusterestnodes(j,2);
            estnodes(cluster(j),3)=clusterestnodes(j,3);
        end
    end
    
end