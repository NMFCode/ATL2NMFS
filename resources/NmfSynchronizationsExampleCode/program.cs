using NMF.Synchronizations;
using NMF.Transformations;

namespace NMFTest
{
    class Program
    {

        static void Main(string[] args)
        {
            FSM2PN fsm2pn = new FSM2PN();

            FSM.FiniteStateMachine fsm = new FSM.FiniteStateMachine();
            PN.PetriNet pn = new PN.PetriNet();


            FillStateMachine(fsm);

            var direction = SynchronizationDirection.LeftToRightForced;
            var changePropagartion = ChangePropagationMode.None;

            var context = fsm2pn.Synchronize(fsm2pn.SynchronizationRule<FSM2PN.AutomataToNet>(), ref fsm, ref pn, direction, changePropagartion);


            var s4 = new FSM.State() { Name = "s4", IsStartState = false };
            fsm.States.Add(s4);
        }

        private static void FillStateMachine(FSM.FiniteStateMachine fsm)
        {
            var s1 = new FSM.State() { Name = "s1", IsStartState = true };
            var s2 = new FSM.State() { Name = "s2" };
            var s3 = new FSM.State() { Name = "s3", IsEndState = true };

            fsm.States.Add(s1);
            fsm.States.Add(s2);
            fsm.States.Add(s3);

            var t1 = new FSM.Transition()
            {
                StartState = s1,
                EndState = s2,
                Input = "a"
            };

            var t2 = new FSM.Transition()
            {
                StartState = s2,
                EndState = s3,
                Input = "a"
            };

            var t3 = new FSM.Transition()
            {
                StartState = s2,
                EndState = s1,
                Input = "b"
            };

            var t4 = new FSM.Transition()
            {
                StartState = s1,
                EndState = s1,
                Input = "b"
            };

            fsm.Transitions.Add(t1);
            fsm.Transitions.Add(t2);
            fsm.Transitions.Add(t3);
            fsm.Transitions.Add(t4);
        }
    }
}
