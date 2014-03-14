function view_dd(filename,res,specific_result)
    raw_data=dlmread(filename,',');
    x = raw_data(:,1);
    y = raw_data(:,2);
    
    rdim = size(raw_data,2) - 3;
    results = raw_data(:,3:end);
    
    
    xmin = min(x);
    xmax = max(x);
    ymin = min(y);
    ymax = max(y);
    
    Xq = linspace(xmin,xmax,res);
    Yq = linspace(ymin,ymax,res);
    [Xq,Yq] = meshgrid(Xq,Yq);
    
    if nargin < 3
        for i=1:rdim
           Zq = griddata(x,y,results(:,i),Xq,Yq);
            figure(i); clf;
                surf(Xq,Yq,Zq,'EdgeColor','none');
%            tri = delaunay(x,y);
%            trisurf(tri,x,y,results(:,i));
        end
    else
        i = specific_result;
        Zq = griddata(x,y,results(:,i),Xq,Yq);        
        surf(Xq,Yq,Zq,'EdgeColor','none');
%         tri = delaunay(x,y);
%         trisurf(tri,x,y,results(:,i));
    end
    
    
    