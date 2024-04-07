function estnodes=estimateLocationsInCluster(nodes,obs,cluster)

	fromInCluster=ismember(obs(:,1),cluster);
	toInCluster=ismember(obs(:,2),cluster);
	obsInCluster=obs(fromInCluster&toInCluster,:);
	%disp(nodesInCluster);
	%disp(obsInCluster);
   nonAnchors=[];
   for i=1:length(cluster)
       %disp(i);
       j=cluster(i);
       if nodes(j,3)<1
           nonAnchors=[nonAnchors;j];
       end
   end
    
    % creates a target function dynamically
	targetFunc=@(x)0;
    for i=1:size(obsInCluster,1)
        from=obsInCluster(i,1);
        to=obsInCluster(i,2);
        theta=obsInCluster(i,3);
        if theta>pi
            theta=theta-2*pi;   % makes theta in [-pi,pi)
        end
        confidence=nodes(from,3);
        if confidence==1
            if nodes(to,3)~=1   % from is anchor, to is non-anchor
                to_index=find(nonAnchors==to);
                targetFunc=@(x)targetFunc(x)+(theta-atan2(nodes(from,2)-x(to_index,2),nodes(from,1)-x(to_index,1)))^2;
            end
        elseif nodes(to,3)~=1   % from and to are non-anchors
                from_index=find(nonAnchors==from);
                to_index=find(nonAnchors==to);
                targetFunc=@(x)targetFunc(x)+(theta-atan2(x(from_index,2)-x(to_index,2),x(from_index,1)-x(to_index,1)))^2;
        end
    end
    options=optimset('PlotFcns',@optimplotfval);
    %result=fminunc(targetFunc,nodes(nonAnchors,1:2),options);
    result=fminsearch(targetFunc,nodes(nonAnchors,1:2),options);
    estnodes=nodes(cluster,:);
    j=1;
    for i=1:size(estnodes,1)
        if estnodes(i,3)<1
            estnodes(i,1)=result(j,1);
            estnodes(i,2)=result(j,2);
            j=j+1;
        end
    end
end
