from mlagents_envs.environment import UnityEnvironment
import matplotlib.pyplot as plt
import numpy as np


env = UnityEnvironment(file_name="SimpleHallway1", seed=1, side_channels=[])
env.reset()
behavior_name = list(env.behavior_specs)[0]

N = 50

S = np.zeros((N,84,84,3))   #State
A = np.zeros((N,1,1))       #Action  
R = np.zeros((N,1))         #Reward

env.reset()

behavior_name = list(env.behavior_specs)[0] 
print(f"Name of the behavior : {behavior_name}")
spec = env.behavior_specs[behavior_name]

print("Number of observations : ", len(spec.observation_shapes))

vis_obs = any(len(shape) == 3 for shape in spec.observation_shapes)
print("Is there a visual observation ?", vis_obs)

if spec.is_action_continuous():
  print("The action is continuous")
if spec.is_action_discrete():
  print("The action is discrete")

print(f"There are {spec.action_size} action(s)")

if spec.is_action_discrete():
  for action, branch_size in enumerate(spec.discrete_action_branches):
    print(f"Action number {action} has {branch_size} different options")
    
decision_steps, terminal_steps = env.get_steps(behavior_name)

env.set_actions(behavior_name, spec.create_empty_action(len(decision_steps)))

env.step()

for index, shape in enumerate(spec.observation_shapes):
  if len(shape) == 3:
    print("Here is the first visual observation")
    plt.imshow(decision_steps.obs[index][0,:,:,:])
    plt.show()

for index, shape in enumerate(spec.observation_shapes):
  if len(shape) == 1:
    print("First vector observations : ", decision_steps.obs[index][0,:])




















#for i in range(N):
#
#    decision_steps, terminal_steps = env.get_steps(behavior_name)
#
#    if len(decision_steps) > 0:
#        S[i] = decision_steps.obs[1][0,:,:,:]
#        R[i] = decision_steps.reward
#    else:  
#        S[i] = terminal_steps.obs[1][0,:,:,:]
#        R[i] = terminal_steps.reward 
#        env.reset()
#
#    plt.imshow(S[i])
#    plt.pause(0.1)
#
#    A[i] = np.array([[2]])
#
#    env.set_actions(behavior_name, A[i])
#    env.step()
#












#A = policy(S2)

#S,R = world(A)

#S2 = compress(S)

#S_t+1 = GAN(S_t)
















