var Swap = React.createClass({

    render() {
        return (
            <section className="Nav">
                <div className="NavAll">
                    <div className="NavDeploy">
                        <h2>New Decentralized Flexible Organization</h2>
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