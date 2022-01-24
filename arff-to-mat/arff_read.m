function [data, relname, nomspec, ftypes] = arff_read(arff_file)
% arff_read(arff_file): Read content of an ARFF file to a MATLAB's struct array.
%
%   INPUT:
%       arff_file => input file (.arff / .arff.gz extension)
% 
%   OUTPUT:
%       relname => relation name (string)
%       DATA => struct array representing data and attributes (n x attrs)
%       nomspec => struct array defining nominal-specification attributes
%       ftypes => array defining the type of attribute:
%               0 = numeric
%               1 = categorical (nominal)
%               2 = string
%               3 = date
%               4 = ordinal if coded as numeric 
%                   NOTE: we have to place "ordinal" in the arff (if is a numeric)          
%               5 = binary
%               6 = ordinal if coded as categorical
%                   NOTE: if ordinal is coded as categorical {}
%                   in the arff, make sure it is ordered
%   NOTES:
%       See ARFF_WRITE to read notes about relname and nomspec.
%       See ARFF format specification on WEKA site.
% 
%   AUTHOR:
%        Valerio De Carolis          <valerio.decarolis@gmail.com>
%
%        28 September 2012 - University of Rome "La Sapienza"
% 
% Last Review: Miriam Santos (11-10-2017)


if nargin < 1
    error('MATLAB:input','Not enough inputs!');
end

if isempty(arff_file)
    error('MATLAB:input','Bad file name!');
end

% check file extention
[~, ~, ext] = fileparts(arff_file);

if strcmpi(ext,'.arff')
    
    % open file
    fid = fopen(arff_file, 'r+t');
    
elseif strcmpi(ext,'.gz')
    
    % use unique temp dir
    %   support multiple calls of arff_read in parallel with the same input file
    outdir = tempname;
    
    % decompress
    dec_files = gunzip(arff_file, outdir);
    
    if ~isempty(dec_files)
        fid = fopen(dec_files{1}, 'r+t');
    else
        error('%s is not a valid arff_file', arff_file);
    end
    
else
    error('%s is not a valid arff_file', arff_file);
end

if fid == -1
    error('MATLAB:file','File not found!');
end

% read relname
relname = [];

while isempty(relname)
    tline = fgetl(fid);
    
    if ~ischar(tline)
        fclose(fid);
        error('MATLAB:file','ARFF file not recognized!');
    end
    
    % avoid parsing @DATA and skip blank lines
    if length(tline) > 9 && tline(1) == '@' && strcmpi(tline(2:9),'RELATION')
        relname = tline(11:end);
        break;
    end
end

% read attributes
fields = {};
ftypes = [];

floop = 1;
fn = 1;

while floop
    tline = fgetl(fid);
    
    if ~ischar(tline)
        break;
    end
    
    % avoid parsing @DATA and skip blank lines
    if length(tline) > 5 && tline(1) == '@' && strcmpi(tline(2:10),'ATTRIBUTE')
        
        %at = strfind(tline, ' ');
        %
        %if length(at) < 2
        %    error('MATLAB:file','ARFF file not recognized!');
        %end
        %
        %fields{fn} = tline(at(1)+1:at(2)-1);
        %typedef = tline(at(2)+1:end);
        
        % parsing using textscan? (good for data, less for attributes)
        A = textscan(tline,'%s %s %s','Whitespace',' \t\b{},');
        
        if isempty(A{1}) || isempty(A{2}) || isempty(A{3})
            fclose(fid);
            error('MATLAB:file','ARFF file not recognized!');
        end
        
        if size(A{1},1) == 1
            fields{fn} = char(A{2});
            typedef = char(A{3});
        else
            fields{fn} = char(A{2}(1));
            bt = strfind(tline,'{');
            typedef = tline(bt(1):end);
        end
        
        
        
        if typedef(1) == '{' && typedef(end) == '}' || typedef(1) == '{' && typedef(end) == '*'
            % %             ftypes(fn) = 1; % is categorical
            
            %nomspec.(fields{fn}) = typedef;
            
            % out is a cell with parsed classes assuming { x, x, x } format
            out = textscan(typedef, '%s', 'Delimiter', ' ,{}*', 'MultipleDelimsAsOne', 1);
            
            % expand cell (avoid cell of cell)
            nomspec.(fields{fn}) = out{:};
        end
        
        
        if typedef(1) == '{' && typedef(end) == '}' && length(strfind(typedef, ',')) == 1
            ftypes(fn) = 5; % isbinary
        elseif typedef(1) == '{' && typedef(end) == '}' && length(strfind(typedef, ',')) > 1
            ftypes(fn) = 1; % iscategorical/nominal
        elseif typedef(1) == '{' && typedef(end) == '*'
            ftypes(fn) = 6; % is ordinal coded as categorical
        elseif strcmpi(typedef,'NUMERIC')
            ftypes(fn) = 0;
        elseif strcmpi(typedef,'STRING')
            ftypes(fn) = 2;
            
            % mrsantos: ordinal has ftype 4
        elseif strcmpi(typedef,'ordinal')
            ftypes(fn) = 4;
        else
            dt = strfind(typedef, ' ');
            
            if ~isempty(dt) && strcmpi(typedef(1:dt(1)-1), 'DATE')
                ftypes(fn) = 3;
                % implement date-format parsing
            else
                fclose(fid);
                error('MATLAB:file','ARFF file not recognized!');
            end
        end
    end
    
    fn = fn + 1;
end

% create data struct
data = struct();

for fn = 1 : length(fields)
    % Erase '[]().'
    if ~isempty(find(fields{fn}=='[' | fields{fn}==']' | fields{fn}=='(' | fields{fn}==')' | fields{fn}=='.'))
        s = fields{fn};
        fields{fn} = s(s~='[' & s~=']' & s~='(' & s~=')' & s~='.');
    end
    
    % Replace '-' with '_'
    if ismember('-',fields{fn})
        s = fields{fn};
        s(strfind(s,'-')) = '_';
        fields{fn} = s;
    end
    
    data.(fields{fn}) = [];
end

% store empty struct
data_tmpl = data;

% rewind file
fseek(fid,0,-1);

% seek data
has_data = 0;

while floop
    tline = fgetl(fid);
    
    if length(tline) == 5 && strcmpi(tline(1:5),'@DATA')
        has_data = 1;
        break;
    end
    
    if ~ischar(tline)
        break;
    end
end

if has_data == 1
    
    dcnt = 1;
    
    while floop
        tline = fgetl(fid);
        
        if length(tline) > 1
            
            % find values
            vt = strfind(tline,',');
            
            % init with empty struct
            data(dcnt) = data_tmpl;
            
            for k = 1 : length(vt) + 1
                
                if k == 1
                    if isempty(vt)
                        content = tline(1:end);
                    else
                        content = tline(1:vt(k)-1);
                    end
                elseif k <= length(vt)
                    content = tline(vt(k-1)+1:vt(k)-1);
                else
                    content = tline(vt(k-1)+1:end);
                end
                
                switch ftypes(k)
                    case 0
                        data(dcnt).(fields{k}) = str2double( content ); % if numeric change to double
                    case 4
                        data(dcnt).(fields{k}) = str2double( content ); % if ordinal change to double
                    case 3
                        data(dcnt).(fields{k}) = datenum( content(2:end-1), 'yyyy-mm-dd HH:MM:SS' );
                    otherwise
                        data(dcnt).(fields{k}) = content;
                end
                
            end
            
            dcnt = dcnt + 1;
            
        end
        
        if ~ischar(tline)
            break;
        end
    end
    
end

% close file
fclose(fid);

% remove temporary directory and decompressed file
if exist('dec_files','var') && ~isempty(dec_files)
    delete(dec_files{1});
    rmdir(outdir, 's');
end

end

% References:
%   [1]: http://www.cs.waikato.ac.nz/ml/weka/arff.html
