namespace PlainBB84Protocol {

    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    operation GetRandomBoolean() : Bool
    {
        use q = Qubit();
        H(q);
        return ResultAsBool(M(q));
    }
    
    operation GetOneRunResults() : String 
    {
        // Generate both Alice's bit and Alice's basis randomly.
        // Allocate a qubit and prepare it in the right basis:
        // |0⟩ and |1⟩ for the rectilinear basis, |+⟩ and |-⟩ for the diagonal basis.
        use q = Qubit();
        let aliceBase = GetRandomBoolean();

        if aliceBase
        {
            H(q);
        }

        if GetRandomBoolean() // flip the qubit at random
        {
            X(q);
        }

        // Send the qubit over to Bob, who generates his basis randomly...
        // ...and measures the qubit in that basis
        let bobBase = GetRandomBoolean();
        if bobBase
        {
            H(q);
        }

        // We know the protocol succeeds if Alice and Bob chose the same bases;
        // otherwise, just discard the run.
        mutable returnValue = "";
        
        if aliceBase == bobBase
        {
            let measurement = M(q); 
            if measurement == Zero
            {
                set returnValue = "0";   
            }
            else
            {
                set returnValue = "1";
            }
		}
        
        Reset(q); // in case the qubit is not measured, return it to |0>.

        return returnValue;
    }



    // Operation marked with @EntryPoint will be executed when running Q# standalone project.
    @EntryPoint()
    operation RunBB84Protocol() : Unit {
        Message("Running BB84 protocol...");
        
        mutable sharedKey = "";

        for i in 1 .. 100
        {
            set sharedKey += GetOneRunResults();
        }

        Message($"Shared key is {sharedKey}");
	}
}