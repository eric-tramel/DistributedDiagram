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

% Get all the points we need
[x,y] = gen_point(N);


% Run the experiment over these points
for i=1:length(x)
%     [x,y] = gen_point(1);
    % Sometimes, for intial points, we have to run multiples, here
    
%     for k=1:length(x)
        result = test_function(x(i),y(i));

        fprintf(output_fid,'%.5e,%.5e,',x(i),y(i));
        for j=1:length(result)
            if j==length(result)
                fprintf(output_fid,'%.5e',result(j));
            else
                fprintf(output_fid,'%.5e,',result(j));
            end

        end
        fprintf(output_fid,'\n');
%     end
end