# frozen_string_literal: true

control 'prometheus services' do
  title 'should be running'

  services =
    case platform[:family]
    when 'redhat'
      %w[
        node_exporter
        prometheus
        blackbox_exporter
        alertmanager
      ]
    else
      %w[
        prometheus
        prometheus-node-exporter
        prometheus-blackbox-exporter
        prometheus-alertmanager
      ]
    end

  services.each do |service|
    describe service(service) do
      it { should be_enabled }
      it { should be_running }
    end
  end

  # prometheus-node-exporter port
  describe port(9100) do
    it { should be_listening }
  end
end
