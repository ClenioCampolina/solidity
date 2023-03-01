(async() => {
    const address = "";  // maps a variable to the contract address
    const abiArray = [];  // maps a variable to the abiArray of the contract. The web3 library needs this abiArray because it cannot guess what are the names of the function or events in the contract.

    const contractInstance = new web3.eth.Contract(abiArray, address);  //creates an instance of a contract (an object related to the contract)

    console.log(await contractInstance.methods.myUint().call());  //using the contract instance, we call the value of a variable in my contract called "myUint" and prints it in the console log

    let accounts = await web3.eth.getAccounts(); //maps a variable to all ethereum wallets connected to the website. This object will be a list

    let txResult = await contractInstance.methods.setMyUint(345).send({from: accounts[0]});     //uses the contract instance to interact with a function in the contract called "setMyUint". 
                                                                                                //In this interaction it passes an uint number as an argument ("345") and uses the first address in the list to indicate what account is interacting with the contract.
                                                                                                //Last, it saves the details of this transaction on the variable "txResult"

    console.log(await contractInstance.methods.myUint().call());  //using the contract instance, we call the value of the variable "myUint" in my contract to see the new value in the console log                                                                                             

    console.log(txResult); // prints the transaction details

})()