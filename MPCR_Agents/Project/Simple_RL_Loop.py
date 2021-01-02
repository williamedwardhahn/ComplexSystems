from mlagents_envs.environment import UnityEnvironment
import matplotlib.pyplot as plt
import numpy as np


env = UnityEnvironment(file_name="SimpleBox3", seed=1, side_channels=[])
env.reset()
behavior_name = list(env.behavior_specs)[0]

N = 15

S = np.zeros((N,84,84,3))   #State
A = np.zeros((N,1,1))       #Action  
R = np.zeros((N,1))         #Reward


for i in range(N):

    decision_steps, terminal_steps = env.get_steps(behavior_name)

    if len(terminal_steps) > 0:
        S[i] = terminal_steps.obs[1][0,:,:,:]
        R[i] = terminal_steps.reward 
        env.reset()
    else:  
        S[i] = decision_steps.obs[1][0,:,:,:]
        R[i] = decision_steps.reward

    print("Reward: ",R)
    plt.imshow(S[i])
    plt.pause(0.1)

    A[i] = np.array([[2]])

    env.set_actions(behavior_name, A[i])
    env.step()





























