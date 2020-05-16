var Swap = React.createClass({

    render() {
        return (
            <section className="Nav">
                <div className="NavAll">
                    <div className="NavDeploy">
                        <h2>New Decentralized Flexible Organization</h2>
                        {React.createElement(window[this.steps[this.state.step]], { allData: (this.state && this.state.allData) || {}, data: this.data[this.state.step], ref: ref => (this.currentElement = ref) && window.setData(this.currentElement.domRoot, this.data[this.state.step]) })}
                        <div className="DeployActions">
                            {this.state.step !== 0 && <a className="DeployNextPrev" href="javascript:;" onClick={this.controller.back}>Back</a>}
                            {this.state.step < (this.steps.length - 1) && <a className="DeployNextPrev" href="javascript:;" onClick={this.controller.next}>Next</a>}
                        </div>
                    </div>
                </div>
            </section>
        );
    }
});