function run_dd(N,output_,gen_point,test_function)

% Were we given a fid or a file name path?
if ischar(output_)
    if exist(output_,'file')
        % Append Mode
        output_fid = fopen(output_,'a');
    else
        % New file
        output_fid = fopen(output_,'w');
    end
else
    output_fid = output_;
end

% Run the experiment over these points
for i=1:N
    [x,y] = gen_point(1);
    result = test_function(x,y);
    
    fprintf(output_fid,'%.5e,%.5e,',x,y);
    for j=1:length(result)
        if j==length(result)
            fprintf(output_fid,'%.5e',result(j));
        else
            fprintf(output_fid,'%.5e,',result(j));
        end
            
    end
    fprintf(output_fid,'\n');
end