from mlagents_envs.environment import UnityEnvironment
from mlagents_envs.environment import ActionTuple, BaseEnv
import matplotlib.pyplot as plt
import numpy as np


env = UnityEnvironment(file_name="Fox1", seed=1, side_channels=[])
env.reset()
behavior_name = list(env.behavior_specs)[0]
spec = env.behavior_specs[behavior_name]

decision_steps, terminal_steps = env.get_steps(behavior_name)

action = spec.action_spec.random_action(len(decision_steps))

env.set_actions(behavior_name, action)

env.step()

decision_steps, terminal_steps = env.get_steps(behavior_name)


actions = np.array([[1,0,0,0]])

action_tuple = ActionTuple()
action_tuple.add_discrete(actions)
env.set_actions(behavior_name, action_tuple)

decision_steps, terminal_steps = env.get_steps(behavior_name)


if len(terminal_steps) > 0:
    s = terminal_steps.obs[0][0,:,:,:]
    r = terminal_steps.reward 
    env.reset()
else: 
    s = decision_steps.obs[0][0,:,:,:]
    r = decision_steps.reward
    
    
print(s.shape)
plt.imshow(s)
plt.show()
