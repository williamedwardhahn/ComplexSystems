from mlagents_envs.environment import UnityEnvironment
from mlagents_envs.side_channel.environment_parameters_channel import EnvironmentParametersChannel

channel = EnvironmentParametersChannel()

env = UnityEnvironment(side_channels=[channel])

channel.set_float_parameter("parameter_1", 2.0)

i = env.step()
