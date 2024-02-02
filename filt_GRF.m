function [vec] = filt_GRF(S, freq)
         vec =S;
            [b_filt,a_filt] = butter(2,  20/(freq/2), 'low');
            names = fieldnames (vec);
            %% filter

            for r = 1 : length(names)
                vec.(names{r, 1})(isnan(vec.(names{r, 1})))=0;
                if  contains((names{r, 1}), 'p') ==1
                    vec.(names{r, 1}) =vec.(names{r, 1});
                else
                    for t = 1:length(vec.(names{r, 1})(1,:))
                        vec.(names{r, 1})(:,t) =  filtfilt(b_filt,a_filt,vec.(names{r, 1})(:,t));
                    end
                end
            end
end