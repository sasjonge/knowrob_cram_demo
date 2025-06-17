from datetime import datetime

from pycram.datastructures.enums import WorldMode
from pycram.designators.action_designator import *
from pycram.designators.object_designator import *
from pycram.plan import ActionNode, DesignatorNode, ResolvedActionNode, PlanNode
from pycram.ros_utils.viz_marker_publisher import VizMarkerPublisher
from pycram.worlds.bullet_world import BulletWorld
from pycrap.ontologies import Milk, Apartment, Robot
from pycram.language import SequentialPlan
from pycram.process_module import simulated_robot
from pycram.ros import create_publisher
from pycram.ros import Time as ROSTime
from pycram.external_interfaces import knowrob

world = BulletWorld(mode=WorldMode.DIRECT)

pr2 = Object("pr2", Robot, "pr2.urdf", pose=PoseStamped.from_list([1.5, 2.15, 0]))
milk = Object("milk", Milk, "milk.stl", pose=PoseStamped.from_list([2.1, 2.35, 0.8]))
apartment = Object("apartment", Apartment, "apartment.urdf")

v = VizMarkerPublisher()

with simulated_robot:
    # The plan that is performed by the robot
    sp = SequentialPlan(
        ParkArmsActionDescription(Arms.BOTH),
        MoveTorsoActionDescription([TorsoState.HIGH]),
        PickUpActionDescription(BelieveObject(types=[Milk]), Arms.LEFT, GraspDescription(Grasp.FRONT, None, False)),
        PlaceActionDescription(BelieveObject(types=[Milk]), PoseStamped.from_list([2.1, 2.35, 0.8]), Arms.LEFT),
    )
    # Plot the created Plan structure before performing it, basically just the actions as written down above
    # sp.plot()
    # Performs the plan on the robot
    sp.perform()
    # Plots the plan after performing it, now the nodes are expanded to the atomic motions
    # sp.plot()
    # sp.plot_bokeh()

world.exit()
v._stop_publishing()
