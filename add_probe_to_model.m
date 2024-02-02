function [model_path_with_probe] = add_probe_to_model(old_model_path)

import org.opensim.modeling.*
import org.opensim.utils.*
fn = utils.
model = Model(old_model_path); % location of the scaled model
mystate = model.initSystem();
model.setName([char(oldModel.getName()), "_probed"])


model_path_with_probe = 2; 
end